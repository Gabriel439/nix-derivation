    let dhallix = ./../dhall/package.dhall

in  let T = ./../dhall/types.dhall

in  let busybox = ./busybox.dhall

in  let `bootstrap-tools.tar.xz` =
          dhallix.fetch-url
          { name =
              "bootstrap-tools.tar.xz"
          , url =
              "http://tarballs.nixos.org/stdenv-linux/x86_64/4907fc9e8d0d82b28b3c56e3a478a2882f1d700f/bootstrap-tools.tar.xz"
          , sha256 =
              "abe3f0727dd771a60b7922892d308da1bc7b082afc13440880862f0c8823c09f"
          , executable =
              False
          }

in  let `unpack-bootstrap-tools.sh` =
          dhallix.fetch-url
          { name =
              "unpack-bootstrap-tools.sh"
          , url =
              "https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/stdenv/linux/bootstrap-tools/scripts/unpack-bootstrap-tools.sh"
          , sha256 =
              "0r0knqg97l05r1rrcmzyjl79rfdgmlslam8as8sq2lba54gyxl5k"
          , executable =
              False
          }

in  dhallix.derivation
    (   λ(store-path : T.Derivation → Text)
      →   dhallix.defaults.Args
        ⫽ { builder =
              dhallix.Builder.Exe "${store-path busybox}"
          , args =
              [ "ash", store-path `unpack-bootstrap-tools.sh` ]
          , name =
              "bootstrap-tools"
          , system =
              dhallix.System.x86_64-linux
          , environment =
              [ { name =
                    "tarball"
                , value =
                    dhallix.Env.`Text` (store-path `bootstrap-tools.tar.xz`)
                }
              ]
          }
    )
