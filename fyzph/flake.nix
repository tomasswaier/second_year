{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.freeglut
            pkgs.gnuplot
						pkgs.libGL
						pkgs.libGLU
						pkgs.pkg-config
          ];
        };
      }
    );
		#gcc main.c -o main -lglut -lGL -lGLU
}




