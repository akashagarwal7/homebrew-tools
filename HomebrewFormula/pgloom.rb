class Pgloom < Formula
  desc "Interactive Postgres ERDs from a folder of SQL files"
  homepage "https://github.com/akashagarwal7/pgloom"
  url "https://github.com/akashagarwal7/pgloom/archive/refs/tags/v0.1.0.tar.gz"
  version "0.1.0"
  sha256 "6d70d44d6736e3a2af4a86fa42b480b5317cdea257d30efdff3fa573dcf59031"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"001_init.sql").write <<~SQL
      create table public.authors (id bigserial primary key, email text not null unique);
      create table public.posts (
        id bigserial primary key,
        author_id bigint not null references public.authors (id) on delete cascade
      );
    SQL

    assert_match "erDiagram", shell_output("#{bin}/pgloom render #{testpath} -f mermaid -o -")

    output = shell_output("#{bin}/pgloom render #{testpath} -f json -o -")
    assert_match "\"tool\": \"pgloom\"", output

    system bin/"pgloom", "render", testpath, "-o", testpath/"erd.html"
    assert_path_exists testpath/"erd.html"
    assert_match "<!doctype html>", (testpath/"erd.html").read
  end
end
