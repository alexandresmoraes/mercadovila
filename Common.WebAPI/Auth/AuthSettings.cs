namespace Common.WebAPI.Auth
{
  public record AuthSettings
  {
    public string SecretKey { get; set; } = null!;
    public string Issuer { get; set; } = null!;
    public string Subject { get; set; } = null!;
    public string Audience { get; set; } = null!;
    public int ExpiresIn { get; set; }
    public int RefreshTokenExpires { get; set; }
    public DateTime Expiration => IssuedAt.Add(TimeSpan.FromMinutes(ExpiresIn));
    public DateTime IssuedAt => DateTime.UtcNow;

    public int RefreshTokenExpiration { get; set; } = 7;
  }
}
