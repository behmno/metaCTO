import { useMutation, useQueryClient } from '@tanstack/react-query';
import { useRouter } from 'next/navigation';
import { authAPI, RegisterRequest } from '@/lib/api';
import { useAuth } from '@/contexts/AuthContext';

export function useLogin() {
  const { login } = useAuth();
  const router = useRouter();
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: authAPI.login,
    onSuccess: (data) => {
      // For now, we'll create a mock user object since the login endpoint doesn't return user data
      // In a real app, you'd either modify the backend to return user data or make a separate call
      const mockUser = {
        id: 1,
        name: 'User',
        email: 'user@example.com',
        created_at: new Date().toISOString(),
      };
      
      login(mockUser, data.access_token);
      queryClient.invalidateQueries();
      router.push('/features');
    },
    onError: (error) => {
      console.error('Login failed:', error);
    },
  });
}

export function useRegister() {
  const { login } = useAuth();
  const router = useRouter();
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (userData: RegisterRequest) => {
      const user = await authAPI.register(userData);
      // After registration, automatically log the user in
      const loginData = await authAPI.login({
        username: userData.email,
        password: userData.password,
      });
      return { user, token: loginData.access_token };
    },
    onSuccess: (data) => {
      login(data.user, data.token);
      queryClient.invalidateQueries();
      router.push('/features');
    },
    onError: (error) => {
      console.error('Registration failed:', error);
    },
  });
}

export function useLogout() {
  const { logout } = useAuth();
  const router = useRouter();
  const queryClient = useQueryClient();

  return () => {
    logout();
    queryClient.clear();
    router.push('/');
  };
}