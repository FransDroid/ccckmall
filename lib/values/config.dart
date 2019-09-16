
class Config{
  static const String appURL = "http://ccckmall.zerahghana.com/api/";
  static const String API_KEY = "reg67yu3er3uf0dfg4r20cve98hty47h28ffr3er3uf0dfg4re7fg0wdJYdeg67yuiX3bbCQazUjAU5qRhiLFXAG6l1";
  static const String article_end_point = appURL + "articles/all/";
  static const String article_next_end_point = appURL + "articles/next/";
  static const String articleBy_end_point = appURL + "articles/by/";
  static const String img_url = "http://ccckmall.zerahghana.com";
  static const String get_comments_by_id = img_url+"/api/comments/by/";
  static const String get_category = appURL + "categories/list/";

  static const String radio_url = img_url + "/app/api/radio.php";
  static const String signUp = appURL + "user/register/"+ API_KEY+"/";
  static const String signIn = appURL + "user/login/{email}/{password}/"+ API_KEY+"/";
  static const String tv_url = img_url + "/app/api/tv.php";
}