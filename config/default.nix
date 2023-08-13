{
  browser = "/usr/bin/firefox";

  git = {
    user = {
      email = "me@mediocregopher.com";
      name = "Brian Picciano";
    };
  };

  awesome = {
    startupExtra = "";
  };

  alacritty = {
    fontSize = 11;
    xdgOpenRules = [
      #{
      #  name = "some-unique-name";
      #  pattern = "regex pattern";

      #  # where $1 is the string which matched pattern
      #  xdgOpen = "https://some-url/$1";
      #}
    ];
  };

  binExtra = [];
}
