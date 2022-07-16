using Microsoft.AspNetCore.Mvc;
using Amazon.DynamoDBv2.DataModel;
using SimpleAPI.Models;
using Amazon.DynamoDBv2;

namespace SimpleAPI.Controllers;

[Route("api/[controller]")]
public class NotesController : ControllerBase
{
    private readonly AmazonDynamoDBClient _dynamoDBClient;
    private readonly DynamoDBContext _dbContext;
    public NotesController()
    {
        AmazonDynamoDBConfig clientConfig = new AmazonDynamoDBConfig();
        _dynamoDBClient = new AmazonDynamoDBClient(clientConfig);
        _dbContext = new DynamoDBContext(_dynamoDBClient);
    }

    // GET api/values
    [HttpGet]
    public async Task<IEnumerable<Note>> Get()
    {
        var notes = _dbContext.ScanAsync<Note>(new List<ScanCondition>());
        var results = await notes.GetRemainingAsync();
        return results;
    }

    // GET api/values/5
    [HttpGet("{id}")]
    public async Task<Note?> Get(Guid id)
    {
        var notes = _dbContext.QueryAsync<Note>(id);
        var results = await notes.GetRemainingAsync();
        return results.FirstOrDefault();
    }

    // POST api/values
    [HttpPost]
    public async Task<Note> Post([FromBody] Note value)
    {
        var batch = _dbContext.CreateBatchWrite<Note>();
        value.Id = Guid.NewGuid();
        batch.AddPutItem(value);
        await batch.ExecuteAsync();
        return value;
    }

    // PUT api/values/5
    [HttpPut("{id}")]
    public async Task<IResult> Put(Guid id, [FromBody] Note value)
    {
        var notes = _dbContext.QueryAsync<Note>(id);
        var results = await notes.GetRemainingAsync();
        var first = results.FirstOrDefault();
        if (first == null)
        {
            return Results.NotFound();
        }
        first.Message = value.Message;
        var batch = _dbContext.CreateBatchWrite<Note>();
        batch.AddPutItem(first);
        await batch.ExecuteAsync();
        return Results.Ok(first);
    }

    // DELETE api/values/5
    [HttpDelete("{id}")]
    public async Task<IResult> Delete(Guid id)
    {
        var notes = _dbContext.QueryAsync<Note>(id);
        var results = await notes.GetRemainingAsync();
        var first = results.FirstOrDefault(); if (first == null)
        {
            return Results.NotFound();
        }
        var batch = _dbContext.CreateBatchWrite<Note>();
        batch.AddDeleteItem(first);
        await batch.ExecuteAsync();
        return Results.Ok();
    }
}