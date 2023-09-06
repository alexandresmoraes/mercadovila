namespace Auth.API.Data.Dto
{
  public record AccountDto
  {
    public string Id { get; set; } = null!;
    public string Username { get; set; } = null!;
    public string Email { get; set; } = null!;
    public string? PhoneNumber { get; set; }
    public string? FotoUrl { get; set; }
    public bool IsAtivo { get; set; }
  }
}