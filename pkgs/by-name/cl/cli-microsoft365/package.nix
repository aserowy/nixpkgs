{ lib
, buildNpmPackage
, fetchFromGitHub
, nodejs_18
}:

buildNpmPackage rec {
  pname = "cli-microsoft365";
  version = "7.2.0";

  src = fetchFromGitHub {
    owner = "pnp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-aBOOMxr4pJ7D0/zA0i8DUZ7RTpP2GT5xmOOvaFgunvs=";
  };

  postPatch = ''
    ln -s npm-shrinkwrap.json package-lock.json
  '';

  postFixup = ''
    wrapProgram $out/bin/m365 \
      --prefix PATH : ${lib.makeBinPath [ nodejs_18 ]}

    wrapProgram $out/bin/m365_chili \
      --prefix PATH : ${lib.makeBinPath [ nodejs_18 ]}

    wrapProgram $out/bin/m365_comp \
      --prefix PATH : ${lib.makeBinPath [ nodejs_18 ]}

    wrapProgram $out/bin/microsoft365 \
      --prefix PATH : ${lib.makeBinPath [ nodejs_18 ]}
  '';

  nodejs = nodejs_18;

  npmDepsHash = "sha256-OwzsSwpEFSoqHf6oridr22FCL25j8VmKQoIFWMkmewQ=";

  npmBuildScript = "build";

  meta = {
    changelog = "https://github.com/pnp/cli-microsoft365/blob/${src.rev}/docs/docs/about/release-notes.mdx";
    description = "Manage Microsoft 365 and SharePoint Framework projects on any platform";
    homepage = "https://aka.ms/cli-m365";
    license = lib.licenses.mit;
    mainProgram = "m365";
    maintainers = with lib.maintainers; [ aserowy ];
  };
}
