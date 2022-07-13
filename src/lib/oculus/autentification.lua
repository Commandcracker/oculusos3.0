-- Autentification
-- By Commandcracker
-- GNU Lesser General Public License v3
-- Last updated: July 6 2022

local base64 = require("/lib/base64")
local sha256 = require("/lib/sha256")
local random = require("/lib/random")

-- https://linuxize.com/post/etc-shadow-file/
local function loadShadow()
    local file = fs.open("/etc/shadow", "r")
    local name, passwordDetails, change, minAge, maxAge, warning, inactivity, expiration, unused = file.readLine():match("(.*):(.*):(.*):(.*):(.*):(.*):(.*):(.*):")
    file.close()

    local hashType, salt, password = passwordDetails:match("$(.*)$(.*)$(.*)")

    return {
        name = name,

        passwordDetails = {
            hashType = hashType,
            salt     = base64.decode(salt),
            password = base64.decode(password)
        },

        change     = change,
        minAge     = minAge,
        maxAge     = maxAge,
        warning    = warning,
        inactivity = inactivity,
        expiration = expiration,
        unused     = unused
    }
end

local function hasPassword()
    return fs.exists("/etc/shadow")
end

local function newPassword(password, randomness)
    -- generate random salt
    -- to make it moor random you could also pass some real random user input to the random function.
    local salt = random.random(randomness)

    --[[ default linux iterations 
        (https://en.wikipedia.org/wiki/Passwd#Shadow_file)
        (https://en.wikipedia.org/wiki/Crypt_(C)#Key_derivation_functions_supported_by_crypt)

        [Scheme id]     [Methode] [Iterations]

        1               MD5       1000
        2, 2a, 2x, 2y   bcrypt    1024 = Cost Factor 10 (iterations = 2^cost_factor)
        5               SHA-256   5000
        6               SHA-512   5000
                        Blowfish  64
    ]]

    -- we use 2000 iterations because ComputerCraft is a bit too slow for 5000.
    -- this may reduce the security of the hash, but if you want you can adjust the iterations.

    -- pbkdf2(pass, salt, iter, dklen)
    local hash = sha256.pbkdf2(password, salt, 2000)

    -- Unix stores the password hash in the B64 encoding
    -- (https://en.wikipedia.org/wiki/Base64#Applications_not_compatible_with_RFC_4648_Base64)

    -- we use the Base64 encoding to store the password hash.
    -- because its more commently used and i don't want to create an B64 library.

    local base64Hash = base64.encode(hash)

    local file = fs.open("/etc/shadow", "w")
    file.write("root:" .. "$5$" .. base64.encode(salt) .. "$" .. base64Hash .. ":" .. os.epoch("utc") .. ":0:99999:7:::")
    file.close()
end

local function isRightPassword(password)
    local shadow = loadShadow()

    --[[ default linux iterations 
        (https://en.wikipedia.org/wiki/Passwd#Shadow_file)
        (https://en.wikipedia.org/wiki/Crypt_(C)#Key_derivation_functions_supported_by_crypt)

        [Scheme id]     [Methode] [Iterations]

        1               MD5       1000
        2, 2a, 2x, 2y   bcrypt    1024 = Cost Factor 10 (iterations = 2^cost_factor)
        5               SHA-256   5000
        6               SHA-512   5000
                        Blowfish  64
    ]]

    -- we use 2000 iterations because ComputerCraft is a bit too slow for 5000.
    -- this may reduce the security of the hash, but if you want you can adjust the iterations.

    -- pbkdf2(pass, salt, iter, dklen)
    local hash = sha256.pbkdf2(password, shadow.passwordDetails.salt, 2000)

    return shadow.passwordDetails.password:isEqual(hash)
end

return {
    hasPassword     = hasPassword,
    newPassword     = newPassword,
    isRightPassword = isRightPassword
}
