namespace SimpleAPI.AppDbContext;

using Microsoft.EntityFrameworkCore;
using SimpleAPI.Models;

public class LambdaDbContext : DbContext
{
    public DbSet<Note> Notes { get; set; }

    public LambdaDbContext(DbContextOptions<LambdaDbContext> options) : base(options)
    {
    }
}