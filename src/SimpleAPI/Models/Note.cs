namespace SimpleAPI.Models;


using Amazon.DynamoDBv2.DataModel;

[DynamoDBTable("Notes")]
public class Note
{
    [DynamoDBHashKey]
    public Guid Id {get; set;}
    public String Message {get; set;}
}