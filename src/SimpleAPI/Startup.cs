namespace SimpleAPI;

using Amazon.SecretsManager.Extensions.Caching;
using Microsoft.EntityFrameworkCore;
using SimpleAPI.AppDbContext;

public class Startup
{
    public Startup(IConfiguration configuration)
    {
        Configuration = configuration;
    }

    public IConfiguration Configuration { get; }

    // This method gets called by the runtime. Use this method to add services to the container
    public void ConfigureServices(IServiceCollection services)
    {
        var cache = new SecretsManagerCache();
        String MySecret = cache.GetSecretString("lambda_container_demo_prod").Result;
        var username = Environment.GetEnvironmentVariable("dbUsername");
        var endpoint = Environment.GetEnvironmentVariable("dbEndpoint");

        services.AddDbContext<LambdaDbContext>((options) =>
        {
            options.UseSqlServer($"Server={endpoint};Database=lambda;User Id={username};Password={MySecret};");
        });
        services.AddControllers();
    }

    // This method gets called by the runtime. Use this method to configure the HTTP request pipeline
    public void Configure(IApplicationBuilder app, IWebHostEnvironment env, LambdaDbContext dbContext)
    {
        dbContext.Database.EnsureCreated();
        if (env.IsDevelopment())
        {
            app.UseDeveloperExceptionPage();
        }

        app.UseHttpsRedirection();

        app.UseRouting();

        app.UseAuthorization();

        app.UseEndpoints(endpoints =>
        {
            endpoints.MapControllers();
            endpoints.MapGet("/", async context =>
            {
                await context.Response.WriteAsync("Welcome to running ASP.NET Core on AWS Lambda");
            });
        });
    }
}