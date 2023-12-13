defmodule News.CalCodes do
  @moduledoc """
  A module for California leginfo URLs.
  """

  @cal_codes %{
    "CONS" => "Constitution",
    "BPC"  => "Business and Professions Code",
    "CIV"  => "Civil Code",
    "CCP"  => "Code of Civil Procedure",
    "COM"  => "Commercial Code",
    "CORP" => "Corporations Code",
    "EDC"  => "Education Code",
    "ELEC" => "Elections Code",
    "EVID" => "Evidence Code",
    "FAM"  => "Family Code",
    "FIN"  => "Financial Code",
    "FGC"  => "Fish and Game Code",
    "GOV"  => "Government Code",
    "HNC"  => "Harbors and Navigation Code",
    "HSC"  => "Health and Safety Code",
    "INS"  => "Insurance Code",
    "LAB"  => "Labor Code",
    "MVC"  => "Military and Veterans Code",
    "PEN"  => "Penal Code",
    "PROB" => "Probate Code",
    "PCC"  => "Public Contract Code",
    "PUC"  => "Public Utilities Code",
    "RTC"  => "Revenue and Taxation Code",
    "SHC"  => "Streets and Highways Code",
    "UIC"  => "Unemployment Insurance Code",
    "VEH"  => "Vehicle Code",
    "WAT"  => "Water Code",
    "WIC"  => "Welfare and Institutions Code"
  }

  @code_abbrevs %{
    "Business and Professions Code" => "Bus & Prof Code",
    "Civil Code"                    => "Civ Code",
    "Code of Civil Procedure"       => "Civ Proc Code",
    "Commercial Code"               => "Com Code",
    "Corporations Code"             => "Corp Code",
    "Education Code"                => "Educ Code",
    "Elections Code"                => "Elec Code",
    "Evidence Code"                 => "Evid Code",
    "Family Code"                   => "Fam Code",
    "Financial Code"                => "Fin Code",
    "Fish and Game Code"            => "Fish & Game Code",
    "Government Code"               => "Govt Code",
    "Harbors and Navigation Code"   => "Harb & Nav Code",
    "Health and Safety Code"        => "Health & Safety Code",
    "Insurance Code"                => "Ins Code",
    "Labor Code"                    => "Lab Code",
    "Military and Veterans Code"    => "Mil & Vet Code",
    "Penal Code"                    => "Penal Code",
    "Probate Code"                  => "Prob Code",
    "Public Contract Code"          => "Pub Cont Code",
    "Public Utilities Code"         => "Pub Util Code",
    "Revenue and Taxation Code"     => "Rev & Tax Code",
    "Streets and Highways Code"     => "Sts & High Code",
    "Unemployment Insurance Code"   => "Unemp Ins Code",
    "Vehicle Code"                  => "Veh Code",
    "Water Code"                    => "Water Code",
    "Welfare and Institutions Code" => "Welf & Inst Code"
  }

  @doc """
  Given a California leginfo code,
  return its Public.Law abbreviation.
  """
  @spec code_to_abbrev(binary) :: binary
  def code_to_abbrev(code) do
    @code_abbrevs[@cal_codes[code]]
  end
end
