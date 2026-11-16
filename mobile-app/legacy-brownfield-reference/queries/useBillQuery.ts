import { useQuery } from "@tanstack/react-query";

export type AnnualFee = {
    head_name?: null | string; // "ANNUAL FEE" | "MAGAZINE, STATIONERY" or any other string
    charges?: null | string;
    conc_amount?: null | number;
    concessionpercentage?: null | number;
    finalvalue?: null | number;
    fee_code?: null | string; // "annual_fee" | "magazine_stationery or any other string
    first_m?: null | number;
    second_m?: null | number;
    third_m?: null | number;
    fourth_m?: null | number;
    fifth_m?: null | number;
    sixth_m?: null | number;
    seventh_m?: null | number;
    eighth_m?: null | number;
    ninth_m?: null | number;
    tenth_m?: null | number;
    eleventh_m?: null | number;
    twelth_m?: null | number;
    first_m_wc?: null | number;
    second_m_wc?: null | number;
    third_m_wc?: null | number;
    fourth_m_wc?: null | number;
    fifth_m_wc?: null | number;
    sixth_m_wc?: null | number;
    seventh_m_wc?: null | number;
    eighth_m_wc?: null | number;
    ninth_m_wc?: null | number;
    tenth_m_wc?: null | number;
    eleventh_m_wc?: null | number;
    twelth_m_wc?: null | number;
};

export type InstallmentData = {
  type?: null | string; // "Quarterly"
  date?: null | string; // "DD-MM-YYYY--DD-MM-YYYY"
  inst_no?: null | string; // "FIRST"
  amount?: null | number;
  recived?: null | string;
  instRecdAmtByDate?: null | number;
  installmentWithoutAny?: null | number;
  receivedTillInstallment?: null | number;
  installment_type?: null | string; // "CURRENT"
  allFineInInst?: null | number;
  singleInstalAmtNumber?: null | number;
  totalToReceive?: null | number;
  recdate?: null | string;
  receipt?: null | string;
  cheq_no?: null | string;
  fine?: null | string;
  amount_payble?: null | number;
  fine_installment?: null | number;
  payable_temporary?: null | number;
  amount_payable_in_installment?: null | number;
};

export type FeeBillData = {
  onlineOfflinePayments?: null | any[];
  all_received_transaction?: null | any[];
  _id?: null | string;
  class?: null | string;
  section?: null | string;
  admission_no?: null | string;
  name?: null | string;
  mobile_no?: null | string;
  status?: null | string; // "done"
  year_session?: null | string; // "YYYY-YY"
  student_type?: null | string; // "OLD"
  carry_forward_show?: null | boolean;
  payment_date?: null | string;
  next_payment_date?: null | string;
  totalNextPayable?: null | number;
  date?: null | string;
  mode?: null | string; // "Quarterly"
  installmentNO?: null | string; // "FIRST"
  time?: null | string; // "2025-03-21T09:40:16.201Z",
  installment?: null | Array<InstallmentData>;
  school_code?: null | string; // "ANSR",
  school?: null | string; // "AN",
  fees?: null | {
      monthlyFee?: null | Array<AnnualFee & {
          charges?: null | number;
          charged_month?: null | number;
      }>;
      annualFee?: null | Array<AnnualFee>;
      totals?: null | number;
      after_concession_total?: null | number;
      pendingFee?: null | number;
  };
  concessionBoolean?: null | boolean;
  concession_type?: null | string; // "STAFF",
  is_it_arrear?: null | boolean;
  totalPayable?: null | number;
  receivingObject?: null | {
      total_received?: null | number;
      total_fine_received?: null | number;
      apr?: null | number;
      may?: null | number;
      jun?: null | number;
      jul?: null | number;
      aug?: null | number;
      sep?: null | number;
      oct?: null | number;
      nov?: null | number;
      dec?: null | number;
      jan?: null | number;
      feb?: null | number;
      mar?: null | number;
      apr_fine?: null | number;
      may_fine?: null | number;
      jun_fine?: null | number;
      jul_fine?: null | number;
      aug_fine?: null | number;
      sep_fine?: null | number;
      oct_fine?: null | number;
      nov_fine?: null | number;
      dec_fine?: null | number;
      jan_fine?: null | number;
      feb_fine?: null | number;
      mar_fine?: null | number;            
  };
  admissionPaymentAmount?: null | number;
  admissionPaymentTime?: null | any;
  fee_type_parent_selected?: null | number;
  filepath?: null | string; // file URL
  saved_at?: null | string; // "2025-03-22T15:19:03.710Z"
};

export type SchoolBillResponse = {
    status?: boolean | null;
    message?: string | null;
    data?: null | {
        // --- common ---
        fee_bill_id?: null | FeeBillData;
        transport_bill_id?: null | FeeBillData;
        hostel_bill_id?: null | FeeBillData;

        // --- Student APIs data ---
        admission_no?: string | null;
        year_branch?: number | null;

        // --- Staff Transport API data ---
        address?: null | {
          local_address?: null | string;
          city?: null | string;
          pincode?: null | string;
        };
        default_year_session?: null | string; // YYYY-YY
        _id?: null | string;
        branch_code?: null | number;
        email?: null | string;
        mobile?: null | string;
        name?: null | string;
        school_code?: null | string; // "ANSR";
        transport_id?: null | string;
    };
    branch_details?: null | {
        years?: null | string[]; // "YYYY-YY"[]
        is_deleted?: null | boolean;
        _id?: null | string;
        branch_code?: null | number;
        branch_phone?: null | string; // "91-11-49340000 - 10";
        branch_email?: null | string;
        branch_opening_hrs?: null | string; // "hh:mm-hh:mm";
        branch_address?: null | string;
        school_id?: null | {
            branches?: null | string[];
            is_deleted?: null | boolean;
            _id?: null | string;
            school_name?: null | string
            school_phone?: null | string;
            school_email?: null | string;
            school_code?: null | string; // "ANSR",
            shift_allowed?: null | boolean;
            school_shifts?: null | Array<{
                _id?: null | string;
                shifts?: null | string;
            }>;
            school_principal?: null | string;
            school_opening_hrs?: null | string; // "hh:mm A.M. - hh:mm P.M."
            school_address?: null | string;
            created_at?: null | string;
            updated_at?: null | string;
            __v?: null | number;
            buildings?: null | Array<{
                building_id?: null | string;
            }>;
            school?: null | string; // "AN"
        };
        created_at?: null | string;
        updated_at?: null | string;
        __v?: null | number;
        school_type?: null | string; // "SENIOR";
        branch_website?: null | `www.${string}.com`;
        default_year?: null | string; // "YYYY-YY"
    };
};

export const useBillQuery = ({
  studentOrStaffId,
  userType,
  token,
  type,
  refetchOnMount = false,
}: {
  studentOrStaffId: string | undefined | null;
  userType: "student" | "staff" | undefined | null;
  token: string | undefined | null;
  type: "school" | "hostel" | "transport" | undefined | null;
  refetchOnMount?: boolean;
}) => {
  const query = useQuery({
    enabled: !!type && !!userType && !!studentOrStaffId,

    queryKey: ["bill", type, userType, studentOrStaffId],

    queryFn: async ({ signal, queryKey }) => {
      const [_k1, billType, userType, studentOrStaffId] = queryKey;

      const BASE_URI = "https://mountcarmelschool.com:4201";

      const BILL_URI = userType === "student"
        ? `${BASE_URI}/${userType}/detail/${billType}-bill/${studentOrStaffId}`
        : `${BASE_URI}/${userType}/${billType}-bill/${studentOrStaffId}`;

      if (!token) {
        return Promise.reject(
          new Error(`Authentication Token is required!!!`)
        );
      }

      const response = await fetch(BILL_URI, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token.replace('Bearer ', '')}`,
        },
        signal,
      });

      // Check if the response status is not OK (2xx)
      if (!response.ok) {
        return Promise.reject(
          new Error(`HTTP error! Status: ${response.status}`)
        );
      }
      const result = await response.json() as null | undefined | SchoolBillResponse;

      // Validate the response structure
      if (typeof result !== "object" || result === null) {
        return Promise.reject(new Error("Invalid response format"));
      }
      const { status, message } = result;

      if (!status) {
        return Promise.reject(new Error(message || "Unknown error occurred!"));
      }
      return result
    },
    refetchOnMount,
    meta: {
      friendlyErrorMessage: "Unable to fetch bill details",
    },
  });

  return query;
};
