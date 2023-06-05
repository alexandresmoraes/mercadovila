namespace Auth.API.Models
{
  public record AccountModel
  {
    public string Id { get; set; } = null!;
    public string Nome { get; set; } = null!;
    public string Username { get; set; } = null!;
    public string Email { get; set; } = null!;
    public string Telefone { get; set; } = null!;
    public string? FotoUrl { get; set; }
    public IEnumerable<string> Roles { get; set; } = null!;
  }
}