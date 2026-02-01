
read_cloud_config_file ()
{
    source "$bashaform/${cloud}/use" "${oci_config:-DEFAULT}" "${oci_config_file:-}"

    loud green printf "\n[%s:%s]\n...\n" "${config_file_path}" "${config_section}"
    loud cyan echo "TENANCY=${TENANCY}$NL..."   
}