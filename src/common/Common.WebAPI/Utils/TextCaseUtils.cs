namespace Common.WebAPI.Utils
{
  public static class TextCaseUtils
  {
    public static string ToPascalCase(string text)
    {
      if (string.IsNullOrEmpty(text))
        return text;

      string[] words = text.Split(new char[] { ' ', '-', '_' }, StringSplitOptions.RemoveEmptyEntries);

      for (int i = 0; i < words.Length; i++)
      {
        words[i] = char.ToUpper(words[i][0]) + words[i].Substring(1);
      }

      return string.Join("", words);
    }
  }
}