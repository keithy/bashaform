

read_cloud_config_file ()
{
    source "$bashaform/${cloud}/use" "${azure_config:-DEFAULT}" "${azure_config_file:-}"

    loud green printf "\n[%s:%s]\n...\n" "${config_file_path}" "${config_section}"
    loud cyan echo "TENANCY=${TENANCY}$NL..."   
}