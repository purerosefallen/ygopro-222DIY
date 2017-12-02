project "ikpMP3"
    kind "StaticLib"

    files { "*.cpp", "*.h", "decoder/*.c", "decoder/*.h" }
    if os.ishost("windows") then
        includedirs { "../irrklang/include" }
    end