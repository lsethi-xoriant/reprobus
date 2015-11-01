# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

    setting = Setting.create!(company_name: 'demo company')
    setting.send_emails_turned_off = true;
    setting.save
    
    user = User.create!( :email => 'hamish@writecode.com.au', :name => 'System', :password => 'password', :password_confirmation => 'password' )

    Currency.create!(:code => 'AED' , :currency => 'United Arab Emirates Dirham' )
    Currency.create!(:code => 'AFN' , :currency => 'Afghanistan Afghani' )
    Currency.create!(:code => 'ALL' , :currency => 'Albania Lek' )
    Currency.create!(:code => 'AMD' , :currency => 'Armenia Dram' )
    Currency.create!(:code => 'ANG' , :currency => 'Netherlands Antilles Guilder' )
    Currency.create!(:code => 'AOA' , :currency => 'Angola Kwanza' )
    Currency.create!(:code => 'ARS' , :currency => 'Argentina Peso' )
    Currency.create!(:code => 'AUD' , :currency => 'Australia Dollar' )
    Currency.create!(:code => 'AWG' , :currency => 'Aruba Guilder' )
    Currency.create!(:code => 'AZN' , :currency => 'Azerbaijan New Manat' )
    Currency.create!(:code => 'BAM' , :currency => 'Bosnia and Herzegovina Convertible Marka' )
    Currency.create!(:code => 'BBD' , :currency => 'Barbados Dollar' )
    Currency.create!(:code => 'BDT' , :currency => 'Bangladesh Taka' )
    Currency.create!(:code => 'BGN' , :currency => 'Bulgaria Lev' )
    Currency.create!(:code => 'BHD' , :currency => 'Bahrain Dinar' )
    Currency.create!(:code => 'BIF' , :currency => 'Burundi Franc' )
    Currency.create!(:code => 'BMD' , :currency => 'Bermuda Dollar' )
    Currency.create!(:code => 'BND' , :currency => 'Brunei Darussalam Dollar' )
    Currency.create!(:code => 'BOB' , :currency => 'Bolivia Boliviano' )
    Currency.create!(:code => 'BRL' , :currency => 'Brazil Real' )
    Currency.create!(:code => 'BSD' , :currency => 'Bahamas Dollar' )
    Currency.create!(:code => 'BTN' , :currency => 'Bhutan Ngultrum' )
    Currency.create!(:code => 'BWP' , :currency => 'Botswana Pula' )
    Currency.create!(:code => 'BYR' , :currency => 'Belarus Ruble' )
    Currency.create!(:code => 'BZD' , :currency => 'Belize Dollar' )
    Currency.create!(:code => 'CAD' , :currency => 'Canada Dollar' )
    Currency.create!(:code => 'CDF' , :currency => 'Congo/Kinshasa Franc' )
    Currency.create!(:code => 'CHF' , :currency => 'Switzerland Franc' )
    Currency.create!(:code => 'CLP' , :currency => 'Chile Peso' )
    Currency.create!(:code => 'CNY' , :currency => 'China Yuan Renminbi' )
    Currency.create!(:code => 'COP' , :currency => 'Colombia Peso' )
    Currency.create!(:code => 'CRC' , :currency => 'Costa Rica Colon' )
    Currency.create!(:code => 'CUC' , :currency => 'Cuba Convertible Peso' )
    Currency.create!(:code => 'CUP' , :currency => 'Cuba Peso' )
    Currency.create!(:code => 'CVE' , :currency => 'Cape Verde Escudo' )
    Currency.create!(:code => 'CZK' , :currency => 'Czech Republic Koruna' )
    Currency.create!(:code => 'DJF' , :currency => 'Djibouti Franc' )
    Currency.create!(:code => 'DKK' , :currency => 'Denmark Krone' )
    Currency.create!(:code => 'DOP' , :currency => 'Dominican Republic Peso' )
    Currency.create!(:code => 'DZD' , :currency => 'Algeria Dinar' )
    Currency.create!(:code => 'EGP' , :currency => 'Egypt Pound' )
    Currency.create!(:code => 'ERN' , :currency => 'Eritrea Nakfa' )
    Currency.create!(:code => 'ETB' , :currency => 'Ethiopia Birr' )
    Currency.create!(:code => 'EUR' , :currency => 'Euro Member Countries' )
    Currency.create!(:code => 'FJD' , :currency => 'Fiji Dollar' )
    Currency.create!(:code => 'FKP' , :currency => 'Falkland Islands (Malvinas) Pound' )
    Currency.create!(:code => 'GBP' , :currency => 'United Kingdom Pound' )
    Currency.create!(:code => 'GEL' , :currency => 'Georgia Lari' )
    Currency.create!(:code => 'GGP' , :currency => 'Guernsey Pound' )
    Currency.create!(:code => 'GHS' , :currency => 'Ghana Cedi' )
    Currency.create!(:code => 'GIP' , :currency => 'Gibraltar Pound' )
    Currency.create!(:code => 'GMD' , :currency => 'Gambia Dalasi' )
    Currency.create!(:code => 'GNF' , :currency => 'Guinea Franc' )
    Currency.create!(:code => 'GTQ' , :currency => 'Guatemala Quetzal' )
    Currency.create!(:code => 'GYD' , :currency => 'Guyana Dollar' )
    Currency.create!(:code => 'HKD' , :currency => 'Hong Kong Dollar' )
    Currency.create!(:code => 'HNL' , :currency => 'Honduras Lempira' )
    Currency.create!(:code => 'HRK' , :currency => 'Croatia Kuna' )
    Currency.create!(:code => 'HTG' , :currency => 'Haiti Gourde' )
    Currency.create!(:code => 'HUF' , :currency => 'Hungary Forint' )
    Currency.create!(:code => 'IDR' , :currency => 'Indonesia Rupiah' )
    Currency.create!(:code => 'ILS' , :currency => 'Israel Shekel' )
    Currency.create!(:code => 'IMP' , :currency => 'Isle of Man Pound' )
    Currency.create!(:code => 'INR' , :currency => 'India Rupee' )
    Currency.create!(:code => 'IQD' , :currency => 'Iraq Dinar' )
    Currency.create!(:code => 'IRR' , :currency => 'Iran Rial' )
    Currency.create!(:code => 'ISK' , :currency => 'Iceland Krona' )
    Currency.create!(:code => 'JEP' , :currency => 'Jersey Pound' )
    Currency.create!(:code => 'JMD' , :currency => 'Jamaica Dollar' )
    Currency.create!(:code => 'JOD' , :currency => 'Jordan Dinar' )
    Currency.create!(:code => 'JPY' , :currency => 'Japan Yen' )
    Currency.create!(:code => 'KES' , :currency => 'Kenya Shilling' )
    Currency.create!(:code => 'KGS' , :currency => 'Kyrgyzstan Som' )
    Currency.create!(:code => 'KHR' , :currency => 'Cambodia Riel' )
    Currency.create!(:code => 'KMF' , :currency => 'Comoros Franc' )
    Currency.create!(:code => 'KPW' , :currency => 'Korea (North) Won' )
    Currency.create!(:code => 'KRW' , :currency => 'Korea (South) Won' )
    Currency.create!(:code => 'KWD' , :currency => 'Kuwait Dinar' )
    Currency.create!(:code => 'KYD' , :currency => 'Cayman Islands Dollar' )
    Currency.create!(:code => 'KZT' , :currency => 'Kazakhstan Tenge' )
    Currency.create!(:code => 'LAK' , :currency => 'Laos Kip' )
    Currency.create!(:code => 'LBP' , :currency => 'Lebanon Pound' )
    Currency.create!(:code => 'LKR' , :currency => 'Sri Lanka Rupee' )
    Currency.create!(:code => 'LRD' , :currency => 'Liberia Dollar' )
    Currency.create!(:code => 'LSL' , :currency => 'Lesotho Loti' )
    Currency.create!(:code => 'LYD' , :currency => 'Libya Dinar' )
    Currency.create!(:code => 'MAD' , :currency => 'Morocco Dirham' )
    Currency.create!(:code => 'MDL' , :currency => 'Moldova Leu' )
    Currency.create!(:code => 'MGA' , :currency => 'Madagascar Ariary' )
    Currency.create!(:code => 'MKD' , :currency => 'Macedonia Denar' )
    Currency.create!(:code => 'MMK' , :currency => 'Myanmar (Burma) Kyat' )
    Currency.create!(:code => 'MNT' , :currency => 'Mongolia Tughrik' )
    Currency.create!(:code => 'MOP' , :currency => 'Macau Pataca' )
    Currency.create!(:code => 'MRO' , :currency => 'Mauritania Ouguiya' )
    Currency.create!(:code => 'MUR' , :currency => 'Mauritius Rupee' )
    Currency.create!(:code => 'MVR' , :currency => 'Maldives (Maldive Islands) Rufiyaa' )
    Currency.create!(:code => 'MWK' , :currency => 'Malawi Kwacha' )
    Currency.create!(:code => 'MXN' , :currency => 'Mexico Peso' )
    Currency.create!(:code => 'MYR' , :currency => 'Malaysia Ringgit' )
    Currency.create!(:code => 'MZN' , :currency => 'Mozambique Metical' )
    Currency.create!(:code => 'NAD' , :currency => 'Namibia Dollar' )
    Currency.create!(:code => 'NGN' , :currency => 'Nigeria Naira' )
    Currency.create!(:code => 'NIO' , :currency => 'Nicaragua Cordoba' )
    Currency.create!(:code => 'NOK' , :currency => 'Norway Krone' )
    Currency.create!(:code => 'NPR' , :currency => 'Nepal Rupee' )
    Currency.create!(:code => 'NZD' , :currency => 'New Zealand Dollar' )
    Currency.create!(:code => 'OMR' , :currency => 'Oman Rial' )
    Currency.create!(:code => 'PAB' , :currency => 'Panama Balboa' )
    Currency.create!(:code => 'PEN' , :currency => 'Peru Nuevo Sol' )
    Currency.create!(:code => 'PGK' , :currency => 'Papua New Guinea Kina' )
    Currency.create!(:code => 'PHP' , :currency => 'Philippines Peso' )
    Currency.create!(:code => 'PKR' , :currency => 'Pakistan Rupee' )
    Currency.create!(:code => 'PLN' , :currency => 'Poland Zloty' )
    Currency.create!(:code => 'PYG' , :currency => 'Paraguay Guarani' )
    Currency.create!(:code => 'QAR' , :currency => 'Qatar Riyal' )
    Currency.create!(:code => 'RON' , :currency => 'Romania New Leu' )
    Currency.create!(:code => 'RSD' , :currency => 'Serbia Dinar' )
    Currency.create!(:code => 'RUB' , :currency => 'Russia Ruble' )
    Currency.create!(:code => 'RWF' , :currency => 'Rwanda Franc' )
    Currency.create!(:code => 'SAR' , :currency => 'Saudi Arabia Riyal' )
    Currency.create!(:code => 'SBD' , :currency => 'Solomon Islands Dollar' )
    Currency.create!(:code => 'SCR' , :currency => 'Seychelles Rupee' )
    Currency.create!(:code => 'SDG' , :currency => 'Sudan Pound' )
    Currency.create!(:code => 'SEK' , :currency => 'Sweden Krona' )
    Currency.create!(:code => 'SGD' , :currency => 'Singapore Dollar' )
    Currency.create!(:code => 'SHP' , :currency => 'Saint Helena Pound' )
    Currency.create!(:code => 'SLL' , :currency => 'Sierra Leone Leone' )
    Currency.create!(:code => 'SOS' , :currency => 'Somalia Shilling' )
    Currency.create!(:code => 'SPL*' , :currency => 'Seborga Luigino' )
    Currency.create!(:code => 'SRD' , :currency => 'Suriname Dollar' )
    Currency.create!(:code => 'STD' , :currency => 'São Tomé and Príncipe Dobra' )
    Currency.create!(:code => 'SVC' , :currency => 'El Salvador Colon' )
    Currency.create!(:code => 'SYP' , :currency => 'Syria Pound' )
    Currency.create!(:code => 'SZL' , :currency => 'Swaziland Lilangeni' )
    Currency.create!(:code => 'THB' , :currency => 'Thailand Baht' )
    Currency.create!(:code => 'TJS' , :currency => 'Tajikistan Somoni' )
    Currency.create!(:code => 'TMT' , :currency => 'Turkmenistan Manat' )
    Currency.create!(:code => 'TND' , :currency => 'Tunisia Dinar' )
    Currency.create!(:code => 'TOP' , :currency => "Tonga Pa'anga" )
    Currency.create!(:code => 'TRY' , :currency => 'Turkey Lira' )
    Currency.create!(:code => 'TTD' , :currency => 'Trinidad and Tobago Dollar' )
    Currency.create!(:code => 'TVD' , :currency => 'Tuvalu Dollar' )
    Currency.create!(:code => 'TWD' , :currency => 'Taiwan New Dollar' )
    Currency.create!(:code => 'TZS' , :currency => 'Tanzania Shilling' )
    Currency.create!(:code => 'UAH' , :currency => 'Ukraine Hryvnia' )
    Currency.create!(:code => 'UGX' , :currency => 'Uganda Shilling' )
    Currency.create!(:code => 'USD' , :currency => 'United States Dollar' )
    Currency.create!(:code => 'UYU' , :currency => 'Uruguay Peso' )
    Currency.create!(:code => 'UZS' , :currency => 'Uzbekistan Som' )
    Currency.create!(:code => 'VEF' , :currency => 'Venezuela Bolivar' )
    Currency.create!(:code => 'VND' , :currency => 'Viet Nam Dong' )
    Currency.create!(:code => 'VUV' , :currency => 'Vanuatu Vatu' )
    Currency.create!(:code => 'WST' , :currency => 'Samoa Tala' )
    Currency.create!(:code => 'XAF' , :currency => 'Communauté Financière Africaine (BEAC) CFA Franc BEAC' )
    Currency.create!(:code => 'XCD' , :currency => 'East Caribbean Dollar' )
    Currency.create!(:code => 'XDR' , :currency => 'International Monetary Fund (IMF) Special Drawing Rights' )
    Currency.create!(:code => 'XOF' , :currency => 'Communauté Financière Africaine (BCEAO) Franc' )
    Currency.create!(:code => 'XPF' , :currency => 'Comptoirs Français du Pacifique (CFP) Franc' )
    Currency.create!(:code => 'YER' , :currency => 'Yemen Rial' )
    Currency.create!(:code => 'ZAR' , :currency => 'South Africa Rand' )
    Currency.create!(:code => 'ZMW' , :currency => 'Zambia Kwacha' )
    Currency.create!(:code => 'ZWD' , :currency => 'Zimbabwe Dollar' )
    
    
    Trigger.create!(:name => 'New Enquiry' , :setting_id => '1' )
    Trigger.create!(:name => 'New Booking' , :setting_id => '1' )
    Trigger.create!(:name => 'Confirmed Booking' , :setting_id => '1' )
    Trigger.create!(:name => 'Payment Received' , :setting_id => '1' )
    Trigger.create!(:name => 'Payment Failed' , :setting_id => '1' )
    Trigger.create!(:name => 'Deposit Due' , :setting_id => '1' )
    Trigger.create!(:name => 'Balance Due Soon' , :setting_id => '1' )
    Trigger.create!(:name => 'Balance Due' , :setting_id => '1' )
    Trigger.create!(:name => 'Balance Overdue' , :setting_id => '1' )
    Trigger.create!(:name => 'Pre-trip' , :setting_id => '1' )
    Trigger.create!(:name => 'Mid-trip' , :setting_id => '1' )
    Trigger.create!(:name => 'Post-trip' , :setting_id => '1' )
    Trigger.create!(:name => 'Trip Anniversary' , :setting_id => '1' )
    Trigger.create!(:name => 'Enquiry Follow Up' , :setting_id => '1' )