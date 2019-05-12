[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls";

$PageCount = [Math]::Ceiling($Results.meta.total/5000)
$CurrentPage = 1;
$TrueCount = 0;
$FalseCount = 0;

do {
    $UriValues = @(
        $CurrentPage
        "&client_id=MTY2MDI5NTN8MTU1NzYyNzA0Ny45Ng&client_secret=0d5a0a8d8340854272e9e0f1e7a450a3acb768c3c121c59af982f8b660b3e0ff"
    )

    $Uri = 'https://api.seatgeek.com/2/venues?page={0}&per_page=5000&{1}' -f $UriValues
    $Results = Invoke-RestMethod -Uri $Uri;
    $Venues = $Results.venues;

    foreach ($Venue in $Venues) {
        if ($Venue.has_upcoming_events -eq "true" -or $Venue.stats.event_count -gt 0 -or $Venue.capacity -gt 0) {
            $TrueCount++
        } else {
            $FalseCount++
        }
    }
    $CurrentPage++
    Clear-Host
    $TrueCount
    $FalseCount

} while ($PageCount -ne $Results.meta.page)

Clear-Host
"True: " + $TrueCount
"False: " + $FalseCount