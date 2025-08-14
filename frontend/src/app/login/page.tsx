'use client';

import {
  Box,
  Paper,
  Typography,
  TextField,
  Button,
  Link as MUILink,
  Alert,
  CircularProgress,
} from '@mui/material';
import Layout from '@/components/Layout/Layout';
import Link from 'next/link';
import { useLogin } from '@/hooks/useAuth';
import { useState } from 'react';
import { ApiError } from '@/types/api';

export default function LoginPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const loginMutation = useLogin();

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    loginMutation.mutate({
      username: email, // API expects username field
      password,
    });
  };

  return (
    <Layout>
      <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '60vh' }}>
        <Paper elevation={3} sx={{ p: 4, maxWidth: 400, width: '100%' }}>
          <Typography variant="h2" component="h1" gutterBottom align="center">
            Login
          </Typography>
          
          {loginMutation.isError && (
            <Alert severity="error" sx={{ mb: 2 }}>
              {(loginMutation.error as ApiError)?.response?.data?.detail || 'Login failed. Please try again.'}
            </Alert>
          )}
          
          <Box component="form" onSubmit={handleSubmit} sx={{ mt: 1 }}>
            <TextField
              margin="normal"
              required
              fullWidth
              id="email"
              label="Email Address"
              name="email"
              autoComplete="email"
              autoFocus
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              disabled={loginMutation.isPending}
            />
            <TextField
              margin="normal"
              required
              fullWidth
              name="password"
              label="Password"
              type="password"
              id="password"
              autoComplete="current-password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              disabled={loginMutation.isPending}
            />
            <Button
              type="submit"
              fullWidth
              variant="contained"
              sx={{ mt: 3, mb: 2 }}
              disabled={loginMutation.isPending}
            >
              {loginMutation.isPending ? (
                <CircularProgress size={24} />
              ) : (
                'Sign In'
              )}
            </Button>
            
            <Box sx={{ textAlign: 'center' }}>
              <MUILink component={Link} href="/register" variant="body2">
                Don&apos;t have an account? Sign up
              </MUILink>
            </Box>
          </Box>
        </Paper>
      </Box>
    </Layout>
  );
}