using Microsoft.AspNetCore.Mvc;
using SimpleAPI.AppDbContext;
using SimpleAPI.Models;

namespace SimpleAPI.Controllers;

[Route("api/[controller]")]
public class NotesController : ControllerBase
{
    private readonly LambdaDbContext _dbContext;
    public NotesController(LambdaDbContext dbContext)
    {
        _dbContext = dbContext;
    }
    // GET api/values
    [HttpGet]
    public IEnumerable<Note> Get()
    {
        return _dbContext.Notes.ToList();
    }

    // GET api/values/5
    [HttpGet("{id}")]
    public Note? Get(Guid id)
    {
        return _dbContext.Notes.Where(x => x.Id == id).FirstOrDefault();
    }

    // POST api/values
    [HttpPost]
    public Note Post([FromBody] Note value)
    {
        _dbContext.Add(value);
        return value;
    }

    // PUT api/values/5
    [HttpPut("{id}")]
    public IResult Put(Guid id, [FromBody] Note value)
    {
        var first = _dbContext.Notes.Where(x => x.Id == id).FirstOrDefault();
        if (first == null) {
            return Results.NotFound();
        }
        first.Message = value.Message;
        _dbContext.Update(first);
        return Results.Ok(first);
    }

    // DELETE api/values/5
    [HttpDelete("{id}")]
    public IResult Delete(Guid id)
    {
        var first = _dbContext.Notes.Where(x => x.Id == id).FirstOrDefault();
        if (first == null) {
            return Results.NotFound();
        }
        _dbContext.Remove(first);
        return Results.Ok();
    }
}