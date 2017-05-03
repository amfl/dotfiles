<?php
/**
 * Usage: php adfly.php <adfly url>
 */

// original function by mikeemoo (mikeemoo/gist:714f39befbeb188dcec9)
// Downloaded from https://gist.github.com/ivanhoe011/3d4a80728c09f72005ba
function resolveAdfly($url) {
    if (!preg_match("@https?:\/\/adf\.ly\/[a-z0-9]+@i", $url)) {
        return $url;
    }
    $contents = file_get_contents($url);
    preg_match("@var ysmm = '([^']+)'@", $contents, $match);

    $ysmm = $match[1];
    $a = $t = '';
    for ($i = 0; $i < strlen($ysmm); $i++) {
        if ($i % 2 == 0) {
            $a .= $ysmm[$i];
        } else {
            $t = $ysmm[$i] . $t;
        }
    }

    $url = base64_decode($a . $t);
    $url = str_replace(' ', '%20', filter_var(strstr($url, 'http'), FILTER_SANITIZE_URL));
    return $url;
}

echo 'Real URL: ', resolveAdfly($argv[1]), "\n";