namespace Auth.API.Data.Dto
{
  public record UserDto
  {
    public string Id { get; set; } = null!;
    public string Username { get; set; } = null!;
    public string Email { get; set; } = null!;
    public string? PhoneNumber { get; set; }
  }
}
