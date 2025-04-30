import "jsr:@supabase/functions-js/edge-runtime.d.ts";

export enum OSType {
    IOS = "ios",
    AOS = "aos"
};

export type VersionEntity_v1 = {
    version: string;
    os: OSType;    
};