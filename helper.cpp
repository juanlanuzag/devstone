int atomic_models_count(std::shared_ptr<cadmium::dynamic::modeling::coupled<Time>> coupled_model) {
    int atomics = 0;
    for(auto& m : coupled_model->_models) {
        std::shared_ptr<cadmium::dynamic::modeling::coupled<TIME>> m_coupled = std::dynamic_pointer_cast<cadmium::dynamic::modeling::coupled<TIME>>(m);
        std::shared_ptr<cadmium::dynamic::modeling::atomic_abstract<TIME>> m_atomic = std::dynamic_pointer_cast<cadmium::dynamic::modeling::atomic_abstract<TIME>>(m);

        if (m_coupled == nullptr) {
            if (m_atomic == nullptr) {
                throw std::domain_error("Invalid submodel is neither coupled nor atomic");
            }
            atomics++;
        } else {
            if (m_atomic != nullptr) {
                throw std::domain_error("Invalid submodel is defined as both coupled and atomic");
            }
            atomics+= atomic_models_count(m_coupled);
        }
    }
    return atomics;
}
