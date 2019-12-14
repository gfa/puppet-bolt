require ["fileinto", "regex"];

if header :comparator "i;ascii-casemap" :contains "X-Spam" "Yes"  {
    fileinto "Junk";
    stop;
}

if header :comparator "i;ascii-casemap" :contains "X-Spam-Flag" "Yes"  {
    fileinto "Junk";
    stop;
}
