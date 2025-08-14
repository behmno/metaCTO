import axios from 'axios';

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000';

// Create axios instance
export const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Types
export interface LoginRequest {
  username: string; // API expects username field for email
  password: string;
}

export interface RegisterRequest {
  name: string;
  email: string;
  password: string;
}

export interface User {
  id: number;
  name: string;
  email: string;
  created_at: string;
}

export interface AuthResponse {
  access_token: string;
  token_type: string;
}

export interface Feature {
  id: number;
  title: string;
  description: string | null;
  author_id: number;
  created_at: string;
  author: User;
  vote_count: number;
}

export interface PaginatedFeatures {
  items: Feature[];
  total: number;
  page: number;
  limit: number;
  pages: number;
}

// API functions
export const authAPI = {
  login: async (credentials: LoginRequest): Promise<AuthResponse> => {
    const formData = new FormData();
    formData.append('username', credentials.username);
    formData.append('password', credentials.password);
    
    const response = await api.post('/auth/login', formData, {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    });
    return response.data;
  },

  register: async (userData: RegisterRequest): Promise<User> => {
    const response = await api.post('/auth/register', userData);
    return response.data;
  },
};

export const featuresAPI = {
  getFeatures: async (page: number = 1, limit: number = 10): Promise<PaginatedFeatures> => {
    const response = await api.get('/features/', {
      params: { page, limit }
    });
    return response.data;
  },

  getFeature: async (id: number): Promise<Feature> => {
    const response = await api.get(`/features/${id}`);
    return response.data;
  },

  createFeature: async (featureData: { title: string; description?: string }): Promise<Feature> => {
    const response = await api.post('/features/', featureData);
    return response.data;
  },
};

export const votesAPI = {
  vote: async (featureId: number) => {
    const response = await api.post('/votes/', { feature_id: featureId });
    return response.data;
  },

  removeVote: async (featureId: number) => {
    const response = await api.delete(`/votes/${featureId}`);
    return response.data;
  },
};

// Request interceptor to add auth token
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('auth_token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Response interceptor to handle auth errors
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('auth_token');
      localStorage.removeItem('user');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);