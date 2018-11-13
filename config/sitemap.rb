# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://pokrex.com"
SitemapGenerator::Sitemap.include_root = false

SitemapGenerator::Sitemap.create do
  add "/", changefreq: "monthly"
  add "/users/sign_in", changefreq: "monthly"
  add "/users/sign_up", changefreq: "monthly"
  add "/about", changefreq: "monthly"
  add "/faq", changefreq: "monthly"
  add "/posts", changefreq: "weekly"
  add "/apps", changefreq: "monthly"
  add "/pricing", changefreq: "monthly"
  add "/donate", changefreq: "monthly"
  add "/posts/grooming-session-is-important", changefreq: "monthly"
  add "/posts/ads", changefreq: "monthly"
  add "/posts/sustainable-service", changefreq: "monthly"
end
