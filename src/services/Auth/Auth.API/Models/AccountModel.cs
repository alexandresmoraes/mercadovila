namespace Auth.API.Models
{
  public record AccountModel
  {
    public string Id { get; private set; }
    public string Nome { get; private set; }
    public string Username { get; private set; }
    public string Email { get; private set; }
    public string Telefone { get; private set; }
    public string? FotoUrl { get; private set; }
    public bool IsAtivo { get; private set; }
    public IEnumerable<string> Roles { get; private set; }

    public AccountModel(string id, string nome, string username, string email, string telefone, string? fotoUrl, bool isAtivo, IEnumerable<string> roles)
    {
      Id = id;
      Nome = nome;
      Username = username;
      Email = email;
      Telefone = telefone;
      FotoUrl = fotoUrl;
      IsAtivo = isAtivo;
      Roles = roles;
    }
  }
}