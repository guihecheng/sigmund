#!/usr/bin/perl

if (@ARGV != 5) {
    die "Not enough arguments, requires 5.";
}

$LOCALROOTDIR = $ARGV[0]; # the location on the server where all these files can be found
                          # The value of Path will be <localrootdir>/<prefix><number>
$PREFIX = $ARGV[1]; #prefix of all the directories and mount points
$VERSION = $ARGV[2];  #1.5 or 2.0
$NUMBER = $ARGV[3]; #number of exports to create
$FSAL = $ARGV[4]; #fsal, used in 2.0 export entries

if ($VERSION == "1.5") {
    foreach(1..${NUMBER}) {
        my $ENTRY =  "EXPORT
{
    Export_Id = 10${_} ;
    Path = \"${LOCALROOTDIR}/${PREFIX}${_}\";
    Root_Access = \"*\";
    RW_Access = \"*\";
    Pseudo = \"/many/${PREFIX}${_}\";
    Anonymous_uid = -2 ;
    Anonymous_gid = -2 ;
    Make_All_Users_Anonymous = FALSE;
    NFS_Protocols = \"3,4\" ;
    Transport_Protocols = \"UDP,TCP\" ;
    SecType = \"sys,krb5,krb5i,krb5p\";
    MaxRead = 32768;
    MaxWrite = 32768;
    Filesystem_id = 192.168 ;
    Cache_Data =  FALSE;
    Tag = \"${PREFIX}${_}\";
    Use_NFS_Commit = TRUE;
    Use_Ganesha_Write_Buffer = FALSE;
    Use_FSAL_UP = TRUE;
    FSAL_UP_Type = \"DUMB\";
}

";
       print $ENTRY;
    }
} elsif ($VERSION == "2.0") {
    foreach(1..${NUMBER}) {
        my $ENTRY =  "EXPORT
{
    Export_Id = 10${_} ;
    Path = \"${LOCALROOTDIR}/${PREFIX}${_}\";
    Pseudo = \"/many/${PREFIX}${_}\";
    Root_Access = "*";
    Access_Type="RW";
    Access="*";
    Anonymous_uid = -2 ;
    Anonymous_gid = -2 ;
    Make_All_Users_Anonymous = FALSE;
    NFS_Protocols = "3,4" ;
    Transport_Protocols = "UDP,TCP" ;
    SecType = "sys,krb5,krb5i,krb5p";
    MaxRead = 1048576;
    MaxWrite = 1048576;
    PrefRead = 1048576;
    PrefWrite = 1048576;
    PrefReaddir = 0;
    Filesystem_id = 564.152 ;
    Tag = \"${PREFIX}${_}\";
    Use_NFS_Commit = TRUE;
    Use_Ganesha_Write_Buffer = FALSE;
    UseCookieVerifier=FALSE;
    FSAL="${FSAL}";
}

";
       print $ENTRY;
    }
}

