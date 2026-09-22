class Pgloom < Formula
  desc "Interactive Postgres ERDs from a folder of SQL files"
  homepage "https://github.com/akashagarwal7/pgloom"
  url "https://github.com/akashagarwal7/pgloom/archive/refs/tags/v0.1.1.tar.gz"
  version "0.1.1"
  sha256 "0c9da82ac46d8ba7a728f6dc66e892e199b59accd24fb243731d4b704dbacfd3"
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
