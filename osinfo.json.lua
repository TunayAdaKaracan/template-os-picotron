function version(version, tags, picotron_build, installer)
    return {
        id="kutup_template_os",
        name = "TemplateOS", -- string
        description = "A template OS for your system", -- [string]
        tags = tags, -- [ string[] ] |> Optional tags for installer
        version = version, -- version string |> This is a required string
        picotron_build = picotron_build, -- version string
        author = { -- [string, {name, github, youtube, discord, mastodon, discord}]
            name = "KutupTilkisi",
            github = "https://github.com/TunayAdaKaracan",
            discord = "@kutuptilkisi.dev"
        },
        entrypoint = "sysboot.lua", -- [string] |> Overrides default entrypoint. "boot.lua" is not a valid entrypoint.,

        -- URI |> If the file is a lua file, it downloads and runs the script. If the file is a json file
        -- It will start iterating each file and download from co-responding url's
        installer = installer,

        -- [bool = false] |> If this is true. It will be using provided path and join them with files in installer.json
        -- This makes sense if all of your files are structured as this:
        -- https://dummy.dummy/v1.0.0/installer.lua 
        -- https://dummy.dummy/v1.0.0/sysboot.lua
        -- https://dummy.dummy/v1.0.0/folder/anotherfile.lua
        --you just need to follow the example of installer.easy.example.json
        easy_installer = true
    }
end

-- Return Versions
return {
    version("1.0.0", {"Alpha"}, "=7", "https://kutuptilkisi.b-cdn.net/template-os/installer.easy.json"),
}
