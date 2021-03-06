class Manager::IndexController < ApplicationController
  def sysinfo
    @component_name = 'manager_func_developing'
    @component_data = {}
    @extend_nav_data = {
      mobile_back_to: manager_path,
      current_title: '系统信息'
    }
  end

  def search
    query = params[:query]
    patients_data = Patient.or({name: /#{query}/}, {id_card: query}, {mobile_phone: query}).map {|p|
      DataFormer.new(p).data
    }
    @component_name = 'manager_search'
    @component_data = {
      patients: patients_data,
      search_url: manager_search_path,
      query: query
    }
    @extend_nav_data = {
      mobile_back_to: manager_path,
      current_title: '患者查找'
    }
  end

  def business_graph
    @component_name = 'demo_new_index'
    @extend_nav_data = {
      mobile_back_to: manager_path,
      current_title: '业务过程'
    }
  end

  def patient_graph
    @component_name = 'demo_patient_graph'
    @component_data = {}
    @extend_nav_data = {
      mobile_back_to: manager_path,
      current_title: '诊疗流程'
    }
  end

  def pe_demo
    @component_name = 'diagnosis'
    @component_data = {}
    @extend_nav_data = {
      mobile_back_to: manager_path,
      current_title: '诊疗流程'
    }
  end
end