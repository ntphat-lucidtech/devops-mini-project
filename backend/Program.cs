var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

var dbHost = Environment.GetEnvironmentVariable("DB_HOST") ?? "localhost";
var dbUser = Environment.GetEnvironmentVariable("POSTGRES_USER") ?? "admin";

app.MapGet("/", () => $"Backend API running! Connected to DB Host: {dbHost}");
app.MapGet("/health", () => Results.Ok(new { status = "Healthy", dbHost = dbHost, user = dbUser }));

app.Run();
